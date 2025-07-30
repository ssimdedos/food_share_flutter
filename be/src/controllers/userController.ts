import { NextFunction, Request, Response } from "express";
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import { _login, _signup } from "../services/userServices";

const JWT_SECRET = process.env.JWT_SECRET || 'ssimdedos**-**'
const ACCESS_TOKEN_EXP = '2h';
const REFRESH_TOKEN_EXP = '15d';
const SALT_ROUND = process.env.SALT_ROUND != undefined ? parseInt(process.env.SALT_ROUND) : 14;

export const signup = async (req:Request, res:Response, next:NextFunction) => {
  const { email, username, password } = req.body;
  const salt = await bcrypt.genSalt(SALT_ROUND);
  const newPassword = await bcrypt.hash(password, salt);
  try {
    const signupRes = await _signup(email, username, newPassword);
    console.log(`회원가입 완료. ACCOUNT_INFO: ID: ${signupRes?.id}, EMAIL: ${signupRes?.email}`);
    res.status(201).json({success:true, msg: '회원가입 성공'});
  } catch (e) {
    console.error('회원가입 실패,', e);
    res.status(500).json({success:false, msg: '회원가입 실패'});
  }
}

export const login = async (req:Request, res:Response, next:NextFunction) => {
  const { email, password } = req.body;

  try {
    const user = await _login(email);
  if (!user || !(await bcrypt.compare(password, user.passwordHash)) || '') {
    console.log('이메일 혹은 비밀번호가 올바르지 않습니다.');
    return res.status(401).json({msg:'이메일 혹은 비밀번호가 올바르지 않습니다.'});
  } 
  const accessToken = jwt.sign(
    {id: user.id, email: user.email, },
    JWT_SECRET,
    {expiresIn: ACCESS_TOKEN_EXP}
  );

  const refreshToken = jwt.sign(
    {id: user.id},
    JWT_SECRET,
    {expiresIn: REFRESH_TOKEN_EXP}
  );
  res.status(200).json({
    success:true,
    accessToken,
    refreshToken,
    user:{
      id: user.id,
      email: user.email,
      username: user.userName
    }
  });

  } catch (err) {
    console.error('로그인 실패, ',err);
    res.status(400).json({success:false, msg:`로그인 실패, ${err}`});
  }
  
}