import {Router} from 'express';
import foodRouter from './foodRouter';
import userRouter from './userRouter';
import chatRouter from './chatRouter';

const mainRouter: Router = Router();

mainRouter.use('/food-posts', foodRouter);
mainRouter.use('/user', userRouter);
mainRouter.use('/chat', chatRouter);

export default mainRouter;