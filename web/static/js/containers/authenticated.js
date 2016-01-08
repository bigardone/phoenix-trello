import React        from 'react';
import { connect }  from 'react-redux';
import Actions      from '../actions/sessions';
import { pushPath } from 'redux-simple-router';

import Header       from '../layouts/header';

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
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

  render() {
    const { currentUser, dispatch } = this.props;

    if (!currentUser) return false;

    return (
      <div className="application-container">
        <Header
          currentUser={currentUser}
          dispatch={dispatch}/>

        <div className='main-container'>
          {this.props.children}
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps)(AuthenticatedContainer);
