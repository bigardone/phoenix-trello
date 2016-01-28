import React, { PropTypes } from 'react';
import Actions              from '../../actions/lists';
import PageClick            from 'react-page-click';

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
    this.props.onSubmit();
  }

  _renderErrors(field) {
    const { errors } = this.props;

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

  componentDidMount() {
    this.refs.name.focus();
  }

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.onCancelClick();
  }

  render() {
    return (
      <PageClick onClick={::this._handleCancelClick}>
        <div className="card form">
          <form id="new_card_form" onSubmit={::this._handleSubmit}>
            <textarea ref="name" id="card_name" type="text" required="true" rows={5}/>
            {::this._renderErrors('name')}
            <button type="submit">Add</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
          </form>
        </div>
      </PageClick>
    );
  }
}

CardForm.propTypes = {
};
