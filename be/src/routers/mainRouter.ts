import {Router} from 'express';
import foodRouter from './foodRouter';
import userRouter from './userRouter';

const mainRouter: Router = Router();

mainRouter.use('/food-posts', foodRouter);
mainRouter.use('/user', userRouter);

export default mainRouter;