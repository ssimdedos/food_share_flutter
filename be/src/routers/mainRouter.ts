import {Router} from 'express';
import foodRouter from './foodRouter';

const mainRouter: Router = Router();

mainRouter.use('/foodPosts', foodRouter);

export default mainRouter;