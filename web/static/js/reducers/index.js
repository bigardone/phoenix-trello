import { combineReducers }  from 'redux';
import { routeReducer }     from 'redux-simple-router';
import session              from './session';
import registration         from './registration';
import boards               from './boards';
import currentBoard         from './current_board';
import currentCard          from './current_card';
import header               from './header';

export default combineReducers({
  routing: routeReducer,
  session: session,
  registration: registration,
  boards: boards,
  currentBoard: currentBoard,
  currentCard: currentCard,
  header: header,
});
