import { Router } from "express";
import { authToken } from "../config/jwt";
import { createChat } from "../controllers/chatController";

const chatRouter:Router = Router();

chatRouter.route('/enter').post(authToken, createChat);

export default chatRouter;