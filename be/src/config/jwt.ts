import { NextFunction, Request, Response } from "express";
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'ssimdedos**-**';

declare global {
  namespace Express {
    interface Request {
      user?: { id:number, email:string };
    }
  }
}

export const authToken = (req:Request, res: Response, next:NextFunction) => {
  const authHeader = req.headers['authorization'];
  const tokenInfo = authHeader && authHeader.split(' ')[1];
  console.log(authHeader);
  console.log(tokenInfo);
  if (tokenInfo == null) {
    return res.status(401).json({success:false, msg: '인증 토큰이 없습니다.'});
  }

  jwt.verify(tokenInfo, JWT_SECRET, (err, user) => {
    if (err) {
      console.error(`토큰 인증 에러, ${err}`);
      return res.status(403).json({success:false, msg: '토큰 인증 에러. 유효하지 않거나 만료된 토큰입니다.'});
    }
    req.user = user as { id:number, email: string };
    next();
  });
}