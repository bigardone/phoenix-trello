import Constants              from '../constants';
import { routeActions }           from 'redux-simple-router';
import { httpGet, httpPost }  from '../utils';

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
      channel.push('create_card', { card: data });
    };
  },
};

export default Actions;
