import Constants  from '../constants';

const initialState = {
  connectedUsers: [],
  channel: null,
  showForm: false,
  showUsersForm: false,
  editingListId: null,
  selectedCard: null,
};

export default function reducer(state = initialState, action = {}) {
  let lists;

  switch (action.type) {
    case Constants.BOARDS_SET_CURRENT_BOARD:
      let selectedCard = state.selectedCard;

      if (selectedCard != null) {
        const { lists } = action.board;

        selectedCard = lists.reduce((p, c) => {
          return { cards: p.cards.concat(c.cards) };
        }).cards.find((card) => { return card.id == selectedCard.id; });
      }

      return { ...state, editingListId: null, selectedCard: selectedCard, ...action.board };

    case Constants.CURRENT_BOARD_CONNECTED_USERS:
      return { ...state, connectedUsers: action.users };

    case Constants.CURRENT_BOARD_CONNECTED_TO_CHANNEL:
      return { ...state, channel: action.channel };

    case Constants.CURRENT_BOARD_SHOW_FORM:
      return { ...state, showForm: action.show };

    case Constants.CURRENT_BOARD_SHOW_USERS_FORM:
      return { ...state, showUsersForm: action.show };

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
      const { invited_users } = state;
      invited_users.push(action.user);

      return { ...state, invited_users: invited_users, showUsersForm: false };

    case Constants.CURRENT_BOARD_EDIT_LIST:
      return { ...state, editingListId: action.listId };

    case Constants.CURRENT_BOARD_EDIT_CARD:
      return { ...state, selectedCard: action.card };

    default:
      return state;
  }
}
