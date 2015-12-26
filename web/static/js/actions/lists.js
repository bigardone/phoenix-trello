import Constants              from '../constants';
import { pushPath }           from 'redux-simple-router';
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

  create: (channel, data) => {
    return dispatch => {
      channel.push('create_list', {list: data});
    };
  },
};

export default Actions;
