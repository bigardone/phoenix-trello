import Constants from '../constants';

const initialState = {
  show: false,
  type: null,
  text: null,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.NOTIFICATION_SHOW_NEW:
      return {...state, type: action.notificationType, text: action.text, show: true};

    case Constants.NOTIFICATION_HIDE:
      return initialState;

    default:
      return state;
  }
}
