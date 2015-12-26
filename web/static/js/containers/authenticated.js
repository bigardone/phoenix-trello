import React        from 'react';
import { connect }  from 'react-redux';
import Actions      from '../actions/sessions';
import { pushPath } from 'redux-simple-router';

import Header       from '../layouts/header';
import Notification from '../components/common/notification';

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  notification: state.notification,
});

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch, currentUser } = this.props;

    if (localStorage.phoenixAuthToken) {
      dispatch(Actions.currentUser());
    } else {
      dispatch(pushPath('/sign_in'));
    }
  }

  _renderNotifications() {
    const {text, show} = this.props.notification;
    const {dispatch} = this.props;

    return (
      <Notification
        dispatch={dispatch}
        show={show}
        text={text}/>
    );
  }

  render() {
    const { currentUser, dispatch } = this.props;

    if (!currentUser) return false;

    return (
      <div className="application-container">
        <Header
          currentUser={currentUser}
          dispatch={dispatch}/>

        {::this._renderNotifications()}

        <div className='main-container'>
          {this.props.children}
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps)(AuthenticatedContainer);
