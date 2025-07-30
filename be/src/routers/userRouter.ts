import { Router } from "express";
import { authToken } from "../config/jwt";
import { login, signup } from "../controllers/userController";

const userRouter: Router = Router();

// 기본 인증
userRouter.route('/login').post(login);
userRouter.route('/signup').post(signup);
// 비밀번호 재설정
userRouter.route('/forgot-password').post();
userRouter.route('/reset-password/:token').post();

// 이메일 인증 관련
userRouter.route('/verify-email/:token').get();
userRouter.route('/resend-verification-email/:token').post();
// 토큰 관련
userRouter.route('/refresh-token').post();
// 소셜 회원가입 관련
userRouter.route('/auth/kakao/cb').get();
userRouter.route('/auth/naver/cb').get();
userRouter.route('/auth/google/cb').get();



export default userRouter;