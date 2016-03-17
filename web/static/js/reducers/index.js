import { combineReducers }  from 'redux';
import { routerReducer }    from 'react-router-redux';
import session              from './session';
import registration         from './registration';
import boards               from './boards';
import currentBoard         from './current_board';
import currentCard          from './current_card';
import header               from './header';

export default combineReducers({
  routing: routerReducer,
  session: session,
  registration: registration,
  boards: boards,
  currentBoard: currentBoard,
  currentCard: currentCard,
  header: header,
});
