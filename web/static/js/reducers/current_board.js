import Constants  from '../constants';

const initialState = {
  connectedUsers: [],
  channel: null,
  showForm: false,
  showUsersForm: false,
  editingListId: null,
  addingNewCardInListId: null,
  error: null,
  fetching: true,
};

export default function reducer(state = initialState, action = {}) {
  let lists;

  switch (action.type) {
    case Constants.CURRENT_BOARD_FETHING:
      return { ...state, fetching: true };

    case Constants.BOARDS_SET_CURRENT_BOARD:
      return { ...state, editingListId: null, fetching: false, ...action.board };

    case Constants.CURRENT_BOARD_CONNECTED_USERS:
      return { ...state, connectedUsers: action.users };

    case Constants.CURRENT_BOARD_CONNECTED_TO_CHANNEL:
      return { ...state, channel: action.channel };

    case Constants.CURRENT_BOARD_SHOW_FORM:
      return { ...state, showForm: action.show };

    case Constants.CURRENT_BOARD_SHOW_MEMBERS_FORM:
      return { ...state, showUsersForm: action.show, error: false };

    case Constants.CURRENT_BOARD_RESET:
      return initialState;

    case Constants.CURRENT_BOARD_LIST_CREATED:
      lists = state.lists;
      lists.push(action.list);

      return { ...state, lists: lists, showForm: false };

    case Constants.CURRENT_BOARD_CARD_CREATED:
      lists = state.lists;
      const { card } = action;

      const listIndex = lists.findIndex((list) => { return list.id == card.list_id; });
      lists[listIndex].cards.push(card);

      return { ...state, lists: lists };

    case Constants.CURRENT_BOARD_MEMBER_ADDED:
      const { members } = state;
      members.push(action.user);

      return { ...state, members: members, showUsersForm: false };

    case Constants.CURRENT_BOARD_ADD_MEMBER_ERROR:
      return { ...state, error: action.error };

    case Constants.CURRENT_BOARD_EDIT_LIST:
      return { ...state, editingListId: action.listId };

    case Constants.CURRENT_BOARD_SHOW_CARD_FORM_FOR_LIST:
      return { ...state, addingNewCardInListId: action.listId };

    default:
      return state;
  }
}
