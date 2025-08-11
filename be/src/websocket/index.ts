import { Server } from "http";
import { WebSocket, WebSocketServer } from "ws";
import { handleStompConnection } from "./controllers/stompController";
import { CustomWebSocket } from "./models/StompModels";

let wss: WebSocketServer | null = null;

export const initWebSocketServer = (httpServer?: Server | null, port?: number) => {
  if(wss) {
    console.warn('활성화된 웹소켓이 존재합니다');
    return;
  }
  if(httpServer) {
    wss = new WebSocketServer({ server: httpServer });
    console.log('웹소켓 서버가 http서버 위에 올라감');
  } else if (port) {
    wss = new WebSocketServer({ port: port });
    console.log(`WebSocketServer listening on port ${port}`);
  } else {
    throw new Error('함수가 올바로 선언되지 않음');
  }
  wss.on('connection', (ws:WebSocket) => {
    const customWs = ws as CustomWebSocket;
    customWs.isAlive = true;
    console.log('Client connected to WS');

    customWs.on('pong', ()=> {
      customWs.isAlive = true;
    });

    handleStompConnection(customWs);
  });
  wss.on('error', (error) => {
    console.error('WS error: ', error);
  });
};

export const sendMessage = (message:string) => {
  if (!wss) {
    console.error('현재 실행 중인 웹 소켓 서버가 없어 메시지를 보낼 수 없습니다.');
    return;
  }
  wss.clients.forEach((ws) => {
    if (ws.readyState === WebSocket.OPEN) {
      ws.send(message);
    }
  });
};