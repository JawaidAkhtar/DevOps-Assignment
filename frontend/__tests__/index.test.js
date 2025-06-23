import { render, screen } from '@testing-library/react';
import Home from '../pages/index';
import axios from 'axios';

jest.mock('axios');

describe('Home page', () => {
  beforeEach(() => {
    // Mock the health check endpoint
    axios.get.mockImplementation((url) => {
      if (url.includes('/api/health')) {
        return Promise.resolve({ data: { status: 'healthy' } });
      }
      if (url.includes('/api/message')) {
        return Promise.resolve({ data: { message: "You've successfully integrated the backend!" } });
      }
      return Promise.reject(new Error('not found'));
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('renders title', () => {
    const { unmount } = render(<Home />);
    expect(screen.getByText(/DevOps Assignment/i)).toBeInTheDocument();
    unmount(); // Unmount to prevent act warning
  });

  it('shows default loading message', () => {
    const { unmount } = render(<Home />);
    expect(screen.getByText(/Loading/i)).toBeInTheDocument();
    unmount(); // Unmount to prevent act warning
  });

  it('shows backend connected status after API call', async () => {
    render(<Home />);
    // Wait for the async update
    expect(await screen.findByText(/Backend is connected!/i)).toBeInTheDocument();
    expect(await screen.findByText(/You've successfully integrated the backend!/i)).toBeInTheDocument();
  });
});
