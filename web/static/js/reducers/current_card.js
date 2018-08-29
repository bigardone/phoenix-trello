import Constants  from '../constants';

const initialState = {
  card: null,
  edit: false,
  error: null,
  fetching: true,
  editTitle: false,
  editDescription: false,
  showMembersSelector: false,
  showTagsSelector: false,
  showPrioritySetter: false,
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.CURRENT_CARD_FETHING:
      return { ...state, fetching: true };

    case Constants.CURRENT_CARD_RESET:
      return initialState;

    case Constants.CURRENT_CARD_SET:
      const { actionCard } = action;
      const { card } = state;

      let edit = false;

      if (edit) {
        edit = !(actionCard.id == card.id);
      }

      let editTitle = false;

      if (editTitle) {
        edit = !(actionCard.id == card.id)
      }

      return { ...state, card: action.card, edit: edit, editTitle: editTitle };

    case Constants.CURRENT_CARD_EDIT:
      return { ...state, edit: action.edit };

    case Constants.CURRENT_CARD_TITLE_EDIT:
      return { ...state, editTitle: action.edit };

    case Constants.CURRENT_CARD_DESCRIPTION_EDIT:
      return { ...state, editDescription: action.edit };

    case Constants.CURRENT_CARD_SHOW_MEMBERS_SELECTOR:
      return { ...state, showMembersSelector: action.show };

    case Constants.CURRENT_CARD_SHOW_TAGS_SELECTOR:
      return { ...state, showTagsSelector: action.show };

    case Constants.CURRENT_CARD_SHOW_PRIORITY_SETTER:
      return { ...state, showPrioritySetter: action.show };

    default:
      return state;
  }
}
