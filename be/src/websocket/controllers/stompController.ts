import { WebSocket } from "ws";
import { sendMessage } from "../index";
import {
  ChatMessage,
  CustomWebSocket,
  StompFrame,
  StompSubscribers,
} from "../models/StompModels";

const subscribers: StompSubscribers = new Map();

/**
 *
 * @param data
 * @returns
 * COMMAND // 명령
 * header1:value1 // 추가 header (선택적)
 * header2:value2 // K:V 형식
 *
 * Body^@ //추가 body (선택적)
 */
const parseStompFrame = (data: string): StompFrame => {
  const lines = data.split("\n");
  const command = lines[0];
  const headers: { [key: string]: string } = {};
  let body = "";
  let headerEndIndex = -1;

  for (let i = 1; i < lines.length; i++) {
    if (lines[i] === "") {
      headerEndIndex = i;
      break;
    }
    const [key, value] = lines[i].split(":");
    if (key && value) {
      headers[key.trim()] = value.trim();
    }
  }

  if (headerEndIndex !== -1) {
    body = lines
      .slice(headerEndIndex + 1)
      .join("\n")
      .replace(/\0$/, ""); //null 제거
  }

  return { command, headers, body };
};

const handleStompMessage = (ws: CustomWebSocket, message: Buffer) => {
  const messageStr = message.toString();
  const { command, headers, body }: StompFrame = parseStompFrame(messageStr);
  console.log(`STOMP Command: ${command}, Headers:`, headers, `Body:`, body);
  switch (command) {
    case "CONNECT":
    case "STOMP":
      ws.send("CONNECTED\nversion:1.2\n\n0");
      break;
    case "SUBSCRIBE":
      const destination = headers.destination;
      if (destination) {
        if (!subscribers.has(destination)) {
          subscribers.set(destination, new Set<CustomWebSocket>());
        }
        subscribers.get(destination)?.add(ws);
        console.log(
          `Client subscribed to: ${destination}. Total subscribers for ${destination}: 
          ${subscribers.get(destination)?.size}`
        );
        if (headers.receipt) {
          ws.send(`RECEIPT\nreceipt-id:${headers.receipt}\n\n\0`);
        }
      } else {
        // destination 헤더가 없는 경우
        ws.send(
          "ERROR\nmessage:Missing destination header for SUBSCRIBE\n\n\0"
        );
      }
      break;
    case "SEND":
      const sendDestination = headers.destination;
      if (sendDestination) {
        try {
          const chatMessage: ChatMessage = JSON.parse(body);
          chatMessage.timestamp = Date.now();
          chatMessage.destination = sendDestination;
          const messageToSend = `MESSAGE\ndestination:${sendDestination}\ncontent-type:text/plain\n\n${JSON.stringify(
            chatMessage
          )}\0`;
          const topicSubscribers = subscribers.get(sendDestination);

          if (topicSubscribers) {
            topicSubscribers.forEach((subscriberWs) => {
              if (subscriberWs.readyState === WebSocket.OPEN) {
                subscriberWs.send(messageToSend);
              }
            });
            console.log(
              `Message sent to ${topicSubscribers.size} subscribers for ${sendDestination}: ${chatMessage.content}`
            );
          } else {
            console.log(
              `No subscribers for ${sendDestination}. Message not broadcast.`
            );
          }
        } catch (e) {
          console.error("Error parsing chat message body:", e);
          ws.send("ERROR\nmessage:Invalid message body format\n\n\0");
        }
      } else {
        ws.send("ERROR\nmessage:Missing destination header for SEND\n\n\0");
      }
      break;
    case "DISCONNECT":
      ws.send(
        `RECEIPT\nreceipt-id:${headers.receipt || "disconnect-ack"}\n\n\0`
      );
      ws.close();
      break;
    case "UNSUBSCRIBE":
      const unsubscribeDestination = headers.id || headers.destination;
      if (unsubscribeDestination) {
        const topicSubscribers = subscribers.get(unsubscribeDestination);
        if (topicSubscribers) {
          topicSubscribers.delete(ws);
          console.log(
            `Client unsubscribed from: ${unsubscribeDestination}. Remaining subscribers: ${topicSubscribers.size}`
          );
          if (topicSubscribers.size === 0) {
            subscribers.delete(unsubscribeDestination); // 구독자가 없으면 맵에서 토픽 제거
          }
        }
        if (headers.receipt) {
          ws.send(`RECEIPT\nreceipt-id:${headers.receipt}\n\n\0`);
        }
      } else {
        ws.send(
          "ERROR\nmessage:Missing id or destination header for UNSUBSCRIBE\n\n\0"
        );
      }
      break;
    default:
      console.warn(`Unhandled STOMP command: ${command}`);
      ws.send(`ERROR\nmessage:Unhandled command "${command}"\n\n\0`);
      break;
  }
};

export const handleStompConnection = (ws: CustomWebSocket) => {
  ws.on("message", (message: Buffer) => {
    handleStompMessage(ws, message);
  });
  ws.on("close", () => {
    console.log("Client disconnected from WebSocket.");
    subscribers.forEach((topicSubscribers) => {
      topicSubscribers.delete(ws);
    });
    for (const [topic, topicSubscribers] of subscribers.entries()) {
      if (topicSubscribers.size === 0) {
        subscribers.delete(topic);
      }
    }
  });
  ws.on("error", (error) => {
    console.error("WebSocket error for client:", error);
    // 에러 발생 시에도 정리 로직 필요
    subscribers.forEach((topicSubscribers) => {
      topicSubscribers.delete(ws);
    });
    for (const [topic, topicSubscribers] of subscribers.entries()) {
      if (topicSubscribers.size === 0) {
        subscribers.delete(topic);
      }
    }
  });
};
