import { WebSocket } from "ws";
import { StompServerSessionLayer } from 'stomp-protocol';

export interface CustomWebSocket extends WebSocket {
  isAlive: boolean;
  // 추가 사용자 정보
}

export interface StompFrame {
  command: string;
  headers: { [key: string]: string };
  body: string;
}

export type StompSubscribers = Map<string, Set<CustomWebSocket>>;

export interface ChatMessage {
  sender: string;
  destination: string; // 메시지가 전송될 토픽/채팅방
  content: string;
  timestamp: number; // 메시지 전송 시간 (Epoch time)
  messageId?: string; // 메시지 고유 ID (선택 사항)
}

export interface StompErrorFrame {
  message: string;
  details?: string;
  receiptId?: string;
}