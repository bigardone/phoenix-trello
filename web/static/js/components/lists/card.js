import React, {PropTypes}       from 'react';
import {DragSource, DropTarget} from 'react-dnd';
import ItemTypes                from '../../constants/item_types';
import Actions                  from '../../actions/current_board';
import ListForm                 from './form';
import CardForm                 from '../../components/cards/form';
import Card                     from '../../components/cards/card';

const listSource = {
  beginDrag(props) {
    return {
      id: props.id,
      name: props.name,
      position: props.position,
    };
  },

  isDragging(props, monitor) {
    return props.id === monitor.getItem().id;
  },
};

const listTarget = {
  drop(targetProps, monitor) {
    const source = monitor.getItem();

    if (source.id !== targetProps.id) {
      const target = {
        id: targetProps.id,
        name: targetProps.name,
        position: targetProps.position,
      };

      targetProps.onDrop({ source, target });
    }
  },
};

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

@DragSource(ItemTypes.LIST, listSource, (connect, monitor) => ({
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging()
}))

@DropTarget(ItemTypes.LIST, listTarget, (connect) => ({
  connectDropTarget: connect.dropTarget()
}))

@DropTarget(ItemTypes.CARD, cardTarget, (connect) => ({
  connectCardDropTarget: connect.dropTarget()
}))

export default class ListCard extends React.Component {
  _renderCards() {
    const { cards, dispatch, boardId } = this.props;

    return cards.map((card) => {
      return (
        <Card
          key={card.id}
          dispatch={dispatch}
          boardId={boardId}
          {...card}
          onDrop={::this._handleDropCard} />
      );
    });
  }

  _renderForm() {
    const { isAddingNewCard } = this.props;
    if (!isAddingNewCard) return false;

    let { id, dispatch, formErrors, channel } = this.props;

    return (
      <CardForm
        listId={id}
        dispatch={dispatch}
        errors={formErrors}
        channel={channel}
        onCancelClick={::this._hideCardForm}
        onSubmit={::this._hideCardForm}/>
    );
  }

  _renderAddNewCard() {
    const { isAddingNewCard } = this.props;
    if (isAddingNewCard) return false;

    return (
      <a className="add-new" href="#" onClick={::this._handleAddClick}>Add a new card...</a>
    );
  }

  _handleAddClick(e) {
    e.preventDefault();

    const { dispatch, id } = this.props;

    dispatch(Actions.showCardForm(id));
  }

  _hideCardForm() {
    const { dispatch } = this.props;

    dispatch(Actions.showCardForm(null));
  }

  _handleDropCard({ source, target }) {
    this.props.onDropCard({ source, target });
  }

  _renderHeader() {
    if (this.props.isEditing) {
      const { id, name, dispatch, channel } = this.props;

      const data = {
        id: id,
        name: name,
      };

      return (
        <ListForm
          list={data}
          dispatch={dispatch}
          channel={channel}
          onCancelClick={::this._handleCancelEditFormClick}/>
      );
    } else {
      return (
        <header onClick={::this._handleHeaderClick}>
          <h4>{this.props.name}</h4>
        </header>
      );
    }
  }

  _handleHeaderClick(e) {
    e.preventDefault();

    const { dispatch, id } = this.props;

    dispatch(Actions.editList(id));
  }

  _handleCancelEditFormClick() {
    const { dispatch } = this.props;

    dispatch(Actions.editList(null));
  }

  render() {
    const { id, connectDragSource, connectDropTarget, connectCardDropTarget, isDragging } = this.props;

    const styles = {
      display: isDragging ? 'none' : 'block',
    };

    return connectDragSource(
      connectDropTarget(
        connectCardDropTarget(
          <div id={`list_${id}`} className="list" style={styles}>
            <div className="inner">
              {::this._renderHeader()}
              <div className="cards-wrapper">
                {::this._renderCards()}
              </div>
              <footer>
                {::this._renderForm()}
                {::this._renderAddNewCard()}
              </footer>
            </div>
          </div>
        )
      )
    );
  }
}

ListCard.propTypes = {
};
