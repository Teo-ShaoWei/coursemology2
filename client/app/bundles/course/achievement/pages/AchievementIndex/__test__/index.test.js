import React from 'react';
import ReactDOM from 'react-dom';
import ReactTestUtils from 'react-dom/test-utils';
import { mount } from 'enzyme';
import ProviderWrapper from 'lib/components/ProviderWrapper';
import storeCreator from '../../../store';
import AchievementIndex from '../index';

describe('<AchievementIndex />', () => {
  it('renders the index page', async () => {
    const store = storeCreator({ achievements: {} });

    const indexPage = mount(
      <ProviderWrapper store={store}>
        <AchievementIndex
          badge={{ url: 'some-url.com' }}
        />
      </ProviderWrapper>
    );

    const newBtn = ReactDOM.findDOMNode(indexPage.find('button').node);
    ReactTestUtils.Simulate.touchTap(newBtn);
    expect(indexPage.find('Dialog').first().props().open).toBe(true);
  });
});
