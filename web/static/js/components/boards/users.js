import React, {PropTypes}       from 'react';
import Gravatar                 from 'react-gravatar';
import ReactCSSTransitionGroup  from 'react-addons-css-transition-group';
import classnames               from 'classnames';

export default class BoardUsers extends React.Component {
  _renderUsers() {
    return this.props.users.map((user) => {
      const index = this.props.connectedUsers.findIndex((cu) => {
        return cu.id === user.id;
      });

      const classes = classnames({connected: index != -1});

      console.log(user.id, classes);

      return (
        <li className={classes} key={user.id}>
          <Gravatar email={user.email} />
        </li>
      );
    });
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
      </ReactCSSTransitionGroup>
      </ul>
    );
  }
}

BoardUsers.propTypes = {
};
