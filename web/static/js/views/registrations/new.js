import React, {PropTypes}   from 'react';
import { connect }          from 'react-redux';
import { Link }             from 'react-router';

import { setDocumentTitle } from '../../utils';
import Actions              from '../../actions/registrations';

class RegistrationsNew extends React.Component {
  componentDidMount() {
    setDocumentTitle('Sign up');
  }

  _handleSubmit(e) {
    e.preventDefault();

    const data = {
      first_name: this.refs.firstName.value,
      last_name: this.refs.lastName.value,
      email: this.refs.email.value,
      password: this.refs.password.value,
      password_confirmation: this.refs.passwordConfirmation.value,
    };

    this.props.dispatch(Actions.signUp(data));
  }

  _renderErrorsFor(ref) {
    const { errors } = this.props;

    if (!errors) return false;

    return errors.map((error, i) => {
      if (error[ref]) {
        return (
          <div key={i} className="error">
            {error[ref]}
          </div>
        );
      }
    });
  }

  render() {
    return (
      <div className='view-container registrations new'>
        <main>
          <header>
            <div className="logo" />
          </header>
          <form onSubmit={::this._handleSubmit}>
            <div className="field">
              <input ref="firstName" type="text" placeholder="First name" required={true} />
              {::this._renderErrorsFor('first_name')}
            </div>
            <div className="field">
              <input ref="lastName" type="text" placeholder="Last name" required={true} />
              {::this._renderErrorsFor('last_name')}
            </div>
            <div className="field">
              <input ref="email" type="email" placeholder="Email" required={true} />
              {::this._renderErrorsFor('email')}
            </div>
            <div className="field">
              <input ref="password" type="password" placeholder="Password" required={true} />
              {::this._renderErrorsFor('password')}
            </div>
            <div className="field">
              <input ref="passwordConfirmation" type="password" placeholder="Confirm password" required={true} />
              {::this._renderErrorsFor('password_confirmation')}
            </div>
            <button type="submit">Sign up</button>
          </form>
          <Link to="/sign_in">Sign in</Link>
        </main>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  errors: state.registration.errors,
});

export default connect(mapStateToProps)(RegistrationsNew);
