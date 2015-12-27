import React, {PropTypes} from 'react';
import CardForm           from '../../components/cards/form';

export default class ListCard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      showForm: false,
    };
  }

  _renderCards() {
    return this.props.cards.map((card) => {
      return (
        <div key={card.id} className="card">
          {card.name}
        </div>
      );
    });
  }

  _renderForm() {
    if (!this.state.showForm) return false;

    let { id, dispatch, formErrors, channel } = this.props;

    return (
      <CardForm
        listId={id}
        dispatch={dispatch}
        errors={formErrors}
        channel={channel}
        onCancelClick={::this._handleCancelClick} />
    );
  }

  _renderAddNewCard() {
    if (this.state.showForm) return false;

    return (
      <a className="add-new" href="#" onClick={::this._handleAddClick}>Add a new card...</a>
    );
  }

  _handleAddClick(e) {
    e.preventDefault();

    this.setState({showForm: true});
  }

  _handleCancelClick() {
    this.setState({showForm: false});
  }

  render() {
    return (
      <div className="list">
        <div className="inner">
          <header>
            <h4>{this.props.name}</h4>
          </header>
          <div className="cards-wrapper">
            {::this._renderCards()}
          </div>
          <footer>
            {::this._renderForm()}
            {::this._renderAddNewCard()}
          </footer>
        </div>
      </div>
    );
  }
}

ListCard.propTypes = {
};
