import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import CardModal          from '../../components/cards/modal';
import Actions            from '../../actions/current_card';

class CardsShowView extends React.Component {
  componentDidMount() {
    const { dispatch, params } = this.props;

    console.log(params);

    dispatch(Actions.showCard(params.id[0], params.id[1]));
  }

  componentWillUnmount() {
    const { dispatch } = this.props;

    dispatch(Actions.reset());
  }

  render() {
    const { channel, currentUser, dispatch, currentCard, currentBoard } = this.props;

    if (!currentCard.card) return false;

    const { card, edit, showMembersSelector, showTagsSelector } = currentCard;

    return (
      <CardModal
        boardId={currentBoard.id}
        boardMembers={currentBoard.members}
        channel={channel}
        currentUser={currentUser}
        dispatch={dispatch}
        card={card}
        edit={edit}
        showMembersSelector={showMembersSelector}
        showTagsSelector={showTagsSelector} />
    );
  }
}

CardsShowView.propTypes = {
};

const mapStateToProps = (state) => ({
  currentCard: state.currentCard,
  currentBoard: state.currentBoard,
  currentUser: state.session.currentUser,
  channel: state.currentBoard.channel,
});

export default connect(mapStateToProps)(CardsShowView);
