import Constants  from '../constants';

const Actions = {
  remove: () => {
    return dispatch => {
      dispatch({
        type: Constants.NOTIFICATION_HIDE,
      });
    };
  },
};

export default Actions;
