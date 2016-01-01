import React, {PropTypes} from 'react';
import {DropTarget}       from 'react-dnd';
import ItemTypes          from '../../constants/item_types';

import CardForm           from '../../components/cards/form';
import Card               from '../../components/cards/card';

const cardTarget = {
  drop(targetProps, monitor) {
    const sourceProps = monitor.getItem();
    const sourceId = sourceProps.id;

    const source = {
      id: sourceProps.id,
      list_id: targetProps.id,
      position: 1024,
    };

    if (!targetProps.cards.length) {
      targetProps.onDropCardWhenEmpty(source);
    }
  },
};

@DropTarget(ItemTypes.CARD, cardTarget, (connect) => ({
  connectDropTarget: connect.dropTarget()
}))

export default class ListCard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      showForm: false,
    };
  }

  _renderCards() {
    const {cards, dispatch} = this.props;

    return cards.map((card) => {
      return (
        <Card
          key={card.id}
          dispatch={dispatch}
          {...card}
          onDrop={::this._handleDropCard} />
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
        onCancelClick={::this._handleCancelClick}
        onSubmit={::this._handleFormSubmit}/>
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

  _handleFormSubmit() {
    this.setState({showForm: false});
  }

  _handleDropCard({source, target}) {
    this.props.onDropCard({source, target});
  }

  render() {
    const {connectDropTarget} = this.props;

    return connectDropTarget(
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
