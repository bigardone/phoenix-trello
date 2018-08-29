import React from 'react';
import { Link } from 'react-router';

export default class MainLayout extends React.Component {
  constructor() {
    super();
  }

  render() {
    return (
      <div>
        {this.props.children}
      </div>
    );
  }
}
