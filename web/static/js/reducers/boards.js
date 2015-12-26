import Constants from '../constants';

const initialState = {
  boards: [],
  showForm: false,
  formErrors: null,
  boardsFetched: false,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.BOARDS_RECEIVED:
      return {...state, boards: action.boards, boardsFetched: true};

    case Constants.BOARDS_SHOW_FORM:
      return {...state, showForm: action.show};

    case Constants.BOARDS_CREATE_ERROR:
      return {...state, formErrors: action.errors};

    case Constants.BOARDS_RESET:
      return initialState;

    default:
      return state;
  }
}
