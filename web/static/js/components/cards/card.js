import React, {PropTypes}       from 'react';
import {DragSource, DropTarget} from 'react-dnd';
import { push }                 from 'react-router-redux';
import ReactGravatar            from 'react-gravatar';

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

      targetProps.onDrop({ source, target });
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
  _handleClick(e) {
    const { dispatch, id, boardId } = this.props;

    this.props.dispatch(push(`/boards/${boardId}/cards/${id}`));
  }

  _renderFooter() {
    let commentIcon = null;
    const { comments, members } = this.props;

    if (comments.length > 0) {
      commentIcon = <small>
        <i className="fa fa-comment-o"/> {comments.length}
      </small>;
    }

    const memberNodes = members.map((member) => {
      return <ReactGravatar className="react-gravatar" key={member.id} email={member.email} https />;
    });

    return (
      <footer>
        {commentIcon}
        {memberNodes}
      </footer>
    );
  }

  _renderTags() {
    const { tags } = this.props;

    const tagsNodes = tags.map((tag) => {
      return (
        <span key={tag} className={`tag ${tag}`}></span>
      );
    });

    return (
      <div className="tags-wrapper">
        {tagsNodes}
      </div>
    );
  }

  render() {
    const { id, connectDragSource, connectDropTarget, isDragging, name } = this.props;

    const styles = {
      display: isDragging ? 'none' : 'block',
    };

    return connectDragSource(
      connectDropTarget(
        <div id={`card_${id}`} className="card" style={styles} onClick={::this._handleClick}>
          {::this._renderTags()}
          {name}
          {::this._renderFooter()}
        </div>
      )
    );
  }
}

Card.propTypes = {
};
