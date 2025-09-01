import express, { Express } from "express";
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import sequelize from "./src/config/database";
import mainRouter from "./src/routers/mainRouter";
import './src/models';

// 채팅 관련
import http from 'http';
import { initWebSocketServer } from "./src/websocket";

dotenv.config();

const app: Express = express();
const httpServer = http.createServer(app);

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended:true }));
app.set('trust proxy', 'loopback');

app.use('/images', (req, res, next) => {
    const requestedFilePath = path.join(process.env.UPLOAD_PATH || 'data/upload', req.url.slice(1)); // '/images/' 제거 후 파일 경로 생성
    // console.log(`[Backend Log] Attempting to serve file: ${requestedFilePath}`);
    next();
}, express.static(process.env.UPLOAD_PATH || 'data/upload', {
    setHeaders: (res, path, stat) => {
        console.log(`[Backend Log] Successfully serving: ${path}`);
    }
}));

app.use('/api', mainRouter);

app.use('/', (req, res) => {
  console.log('/ 요청');
  const clientIp = req.ip;
  const clientIps = req.ips;
  res.status(200).json(`클라이언트 IP: ${clientIp}, 모든 클라이언트 IP: ${clientIps}`);
});

const PORT: number = parseInt(process.env.PORT as string, 10) || 3037;
const WEB_SOCKET_PORT:number = parseInt(process.env.WEB_SOCKET_PORT as string, 10) || 3039;

sequelize.sync().then(() => {
  httpServer.listen(PORT, () => {
    console.log(`SERVER is running on port ${PORT}`);
  });
}).catch(err => {
  console.error('서버 실행 불가능, ', err);
});

initWebSocketServer(null, WEB_SOCKET_PORT);