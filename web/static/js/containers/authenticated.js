import React        from 'react';
import { connect }  from 'react-redux';
import Actions      from '../actions/sessions';
import { routeActions } from 'redux-simple-router';

import Header       from '../layouts/header';

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch, currentUser } = this.props;

    if (localStorage.phoenixAuthToken) {
      dispatch(Actions.currentUser());
    } else {
      dispatch(routeActions.push('/sign_in'));
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

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
});

export default connect(mapStateToProps)(AuthenticatedContainer);
