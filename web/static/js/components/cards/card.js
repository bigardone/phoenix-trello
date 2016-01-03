import React, {PropTypes}       from 'react';
import {DragSource, DropTarget} from 'react-dnd';

import ItemTypes                from '../../constants/item_types';
import Actions                  from '../../actions/current_board';

const cardSource = {
  beginDrag(props) {
    return {
      id: props.id,
      list_id: props.list_id,
      name: props.name,
      position: props.position,
    };
  },

  isDragging(props, monitor) {
    return props.id === monitor.getItem().id;
  },
};

const cardTarget = {
  drop(targetProps, monitor) {
    const source = monitor.getItem();

    if (source.id !== targetProps.id) {
      const target = {
        id: targetProps.id,
        list_id: targetProps.list_id,
        name: targetProps.name,
        position: targetProps.position,
      };

      targetProps.onDrop({source, target});
    }
  },
};

@DragSource(ItemTypes.CARD, cardSource, (connect, monitor) => ({
  connectDragSource: connect.dragSource(),
  isDragging: monitor.isDragging()
}))

@DropTarget(ItemTypes.CARD, cardTarget, (connect) => ({
  connectDropTarget: connect.dropTarget()
}))

export default class Card extends React.Component {
  render() {
    const {connectDragSource, connectDropTarget, isDragging, name} = this.props;

    const styles = {
      display: isDragging ? 'none' : 'block',
    };

    return connectDragSource(
      connectDropTarget(
        <div className="card" style={styles}>
          {name}
        </div>
      )
    );
  }
}

Card.propTypes = {
};
