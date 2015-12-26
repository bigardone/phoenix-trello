import React, { PropTypes } from 'react';
import Actions              from '../../actions/boards';

export default class BoardForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();

    let { dispatch }                    = this.props;
    let { name, defaultLanguage, file } = this.refs;

    let data = {
      name: name.value,
    };

    dispatch(Actions.create(data));
  }

  _renderErrors(field) {
    const {errors} = this.props;

    if (!errors) return false;

    return errors.map((error, i) => {
      if (error[field]) {
        return (
          <div key={i} className="error">
            {error[field]}
          </div>
        );
      }
    });
  }

  render() {
    return (
      <div className="board form">
        <div className="inner">
          <h3>New board</h3>
          <form onSubmit={::this._handleSubmit}>
            <input ref="name" type="text" placeholder="Board name" required="true"/>
            {::this._renderErrors('name')}
            <button type="submit">Create board</button>
          </form>
        </div>
      </div>
    );
  }
}

BoardForm.propTypes = {
};
