import React                    from 'react';
import ReactDOM                 from 'react-dom';
import { browserHistory }       from 'react-router';
import configureStore           from './store';
import Root                     from './containers/root';

const store  = configureStore(browserHistory);

const target = document.getElementById('main_container');
const node = <Root routerHistory={browserHistory} store={store}/>;

ReactDOM.render(node, target);
