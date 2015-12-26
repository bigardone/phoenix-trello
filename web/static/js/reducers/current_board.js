import Constants  from '../constants';
import uniq       from 'lodash/array/uniq';
import cloneDeep  from 'lodash/lang/cloneDeep';
import sortBy     from 'lodash/collection/sortBy';
import get        from 'lodash/object/get';

const initialState = {
  connectedUsers: [],
  channel: null,
  showForm: false,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.BOARDS_SET_CURRENT_BOARD:
      return {...state, ...action.board};

    case Constants.CURRENT_BOARD_CONNECTED_USERS:
      return {...state, connectedUsers: action.users};

    case Constants.CURRENT_BOARD_CONNECTED_TO_CHANNEL:
      return {...state, channel: action.channel};

    case Constants.CURRENT_BOARD_SHOW_FORM:
      return {...state, showForm: action.show};

    case Constants.CURRENT_BOARD_RESET:
      return initialState;

    case Constants.CURRENT_BOARD_LIST_CREATED:
      const {lists} = state;
      lists.push(action.list);

      return {...state, lists: lists, showForm: false};

    default:
      return state;
  }
}
