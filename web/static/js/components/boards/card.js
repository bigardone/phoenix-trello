import React, {PropTypes} from 'react';
import { pushPath }       from 'redux-simple-router';

export default class BoardCard extends React.Component {
  _handleClick = () => {
    this.props.dispatch(pushPath(`/boards/${this.props.id}`));
  }

  render() {
    return (
      <div className="board" onClick={this._handleClick}>
        <div className="inner">
          <h4>{this.props.name}</h4>
        </div>
      </div>
    );
  }
}

BoardCard.propTypes = {
};
