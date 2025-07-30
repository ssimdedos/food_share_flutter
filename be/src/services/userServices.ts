import User from "../models/User";

export const _signup = async (email:string, username:string, password:string):Promise<User | null> => {
  const data = {
    email: email,
    passwordHash: password,
    emailVerified: true,
    userName: username
  };
  return User.create(data);
}

export const _login = async (email:string) => {
  return User.findOne({where: {email}});
}
