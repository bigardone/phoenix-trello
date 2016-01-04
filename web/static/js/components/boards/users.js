import React, {PropTypes}       from 'react';
import Gravatar                 from 'react-gravatar';
import ReactCSSTransitionGroup  from 'react-addons-css-transition-group';
import classnames               from 'classnames';
import PageClick                from 'react-page-click';
import Actions                  from '../../actions/current_board';

export default class BoardUsers extends React.Component {
  _renderUsers() {
    return this.props.users.map((user) => {
      const index = this.props.connectedUsers.findIndex((cu) => {
        return cu.id === user.id;
      });

      const classes = classnames({connected: index != -1});

      return (
        <li className={classes} key={user.id}>
          <Gravatar email={user.email} https/>
        </li>
      );
    });
  }

  _renderAddNewUser() {
    if (!this.props.currentUserIsOwner) return false;

    return (
      <li>
        <a onClick={::this._handleAddNewClick} className="add-new" href="#"><i className="fa fa-plus"/></a>
        {::this._renderForm()}
      </li>
    );
  }

  _renderForm() {
    if (!this.props.show) return false;

    return (
      <PageClick onClick={::this._handleCancelClick}>
        <ul className="drop-down active">
          <li>
            <form onSubmit={::this._handleSubmit}>
              <h4>Add new members</h4>
              <input ref="email" type="email" required={true} placeholder="Member email"/>
              <button type="submit">Add member</button> or <a onClick={::this._handleCancelClick} href="#">cancel</a>
            </form>
          </li>
        </ul>
      </PageClick>
    );
  }

  _handleAddNewClick(e) {
    e.preventDefault();

    this.props.dispatch(Actions.showUsersForm(true));
  }

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.dispatch(Actions.showUsersForm(false));
  }

  _handleSubmit(e) {
    e.preventDefault();

    const {email} = this.refs;

    if (email.value === '') return false;

    return this.props.onNewMemberSubmit(email.value);
  }

  render() {
    return (
      <ul className="board-users">
      <ReactCSSTransitionGroup
        transitionName="avatar"
        transitionAppear={true}
        transitionAppearTimeout={500}
        transitionEnterTimeout={500}
        transitionLeaveTimeout={300}>
        {::this._renderUsers()}
        {::this._renderAddNewUser()}
      </ReactCSSTransitionGroup>
      </ul>
    );
  }
}

BoardUsers.propTypes = {
};
