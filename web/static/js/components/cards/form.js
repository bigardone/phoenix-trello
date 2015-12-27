import React, { PropTypes } from 'react';
import Actions              from '../../actions/lists';

export default class CardForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();

    let { dispatch, channel } = this.props;
    let { name }              = this.refs;

    let data = {
      list_id: this.props.listId,
      name: name.value,
    };

    dispatch(Actions.createCard(channel, data));
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

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.onCancelClick();
  }

  render() {
    return (
      <div className="card form">
        <form onSubmit={::this._handleSubmit}>
          <textarea ref="name" type="text" required="true" rows={5}/>
          {::this._renderErrors('name')}
          <button type="submit">Add</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
        </form>
      </div>
    );
  }
}

CardForm.propTypes = {
};
