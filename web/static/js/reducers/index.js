import { combineReducers }  from 'redux';
import { routeReducer }     from 'redux-simple-router';
import session              from './session';
import registration         from './registration';
import notification         from './notification';
import boards               from './boards';
import currentBoard         from './current_board';

export default combineReducers({
  routing: routeReducer,
  session: session,
  registration: registration,
  notification: notification,
  boards: boards,
  currentBoard: currentBoard,
});
