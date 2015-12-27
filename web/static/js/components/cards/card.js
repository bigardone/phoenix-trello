import React, {PropTypes} from 'react';

export default class Card extends React.Component {
  render() {
    const {name} = this.props;

    return (
      <div className="card">
        {name}
      </div>
    );
  }
}

Card.propTypes = {
};
