import React, { PropTypes } from 'react';
import Actions              from '../../actions/lists';
import PageClick                from 'react-page-click';

export default class ListForm extends React.Component {
  componentDidMount() {
    this.refs.name.focus();
  }

  _handleSubmit(e) {
    e.preventDefault();

    const { dispatch, channel, list } = this.props;
    const { name } = this.refs;

    const data = {
      id: list ? list.id : null,
      name: name.value,
    };

    dispatch(Actions.save(channel, data));
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

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.onCancelClick();
  }

  render() {
    const defaultValue = this.props.list ? this.props.list.name : '';
    const buttonText   = this.props.list ? 'Update list' : 'Save list';

    return (
      <PageClick onClick={::this._handleCancelClick}>
        <div className="list form">
          <div className="inner">
            <form id="new_list_form" onSubmit={::this._handleSubmit}>
              <input ref="name" id="list_name" type="text" defaultValue={defaultValue} placeholder="Add a new list..." required="true"/>
              {::this._renderErrors('name')}
              <button type="submit">{buttonText}</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
            </form>
          </div>
        </div>
      </PageClick>
    );
  }
}

ListForm.propTypes = {
};
