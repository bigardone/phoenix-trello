import React, {PropTypes} from 'react';
import { connect }        from 'react-redux';
import CardModal          from '../../components/cards/modal';
import Actions            from '../../actions/current_card';


class CardsShowView extends React.Component {
  componentDidMount() {
    const { dispatch, params } = this.props;


    dispatch(Actions.showCard(this.getCard(params.id[1])));
  }

  componentWillUnmount() {
    const { dispatch } = this.props;

    dispatch(Actions.reset());
  }

  getCard(id) {
    let cards = [];
    this.props.currentBoard.lists.forEach((list) => { cards = cards.concat(list.cards) });

    return cards.find( (c) => { return c.id === +id  });
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
