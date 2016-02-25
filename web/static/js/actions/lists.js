import Constants from '../constants';

const Actions = {
  showForm: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.LISTS_SHOW_FORM,
        show: show,
      });
    };
  },

  save: (channel, data) => {
    return dispatch => {
      const topic = data.id ? 'list:update' : 'lists:create';

      channel.push(topic, { list: data });
    };
  },

  createCard: (channel, data) => {
    return dispatch => {
      channel.push('cards:create', { card: data });
    };
  },
};

export default Actions;
