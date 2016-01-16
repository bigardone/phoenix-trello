import Constants from '../constants';

const initialState = {
  ownedBoards: [],
  invitedBoards: [],
  showForm: false,
  formErrors: null,
  ownedFetched: false,
  fetching: true,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.BOARDS_FETCHING:
      return { ...state, fetching: true };

    case Constants.BOARDS_RECEIVED:
      return { ...state, ownedBoards: action.ownedBoards, invitedBoards: action.invitedBoards, fetching: false };

    case Constants.BOARDS_SHOW_FORM:
      return { ...state, showForm: action.show };

    case Constants.BOARDS_CREATE_ERROR:
      return { ...state, formErrors: action.errors };

    case Constants.BOARDS_RESET:
      return initialState;

    default:
      return state;
  }
}
