import { Test, TestingModule } from '@nestjs/testing';
import { AppService } from './app.service';
import { createClient } from '@supabase/supabase-js';

jest.mock('@supabase/supabase-js', () => ({
  createClient: jest.fn(() => ({
    from: jest.fn().mockReturnThis(),
    select: jest.fn().mockReturnThis(),
    eq: jest.fn().mockReturnThis(),
    on: jest.fn().mockReturnThis(),
    subscribe: jest.fn(),
  })),
}));

describe('AppService', () => {
  let appService: AppService;
  let supabaseClient: any;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      providers: [AppService],
    }).compile();

    appService = app.get<AppService>(AppService);
    supabaseClient = createClient(
      process.env.SUPABASE_URL,
      process.env.SUPABASE_ANON_KEY
    );
  });

  it('should be defined', () => {
    expect(appService).toBeDefined();
  });

  it('should return notifications', async () => {
    const userId = 'test-user-id';
    const notifications = [
      { id: 1, type: 1, user_id: userId, event_id: 1 },
    ];
    const typeData = [{ name: 'info' }];
    const eventData = [
      {
        description: 'Event description',
        is_private: false,
        title: 'Event title',
        location: 'Event location',
        max_attendees: 100,
        start_date_time: '2023-01-01T00:00:00Z',
        end_date_time: '2023-01-01T01:00:00Z',
      },
    ];

    supabaseClient.from.mockImplementation((table) => {
      switch (table) {
        case 'notifications':
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockResolvedValue({ data: notifications, error: null }),
          };
        case 'notification_types':
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockResolvedValue({ data: typeData, error: null }),
          };
        case 'events':
          return {
            select: jest.fn().mockReturnThis(),
            eq: jest.fn().mockResolvedValue({ data: eventData, error: null }),
          };
        default:
          return this;
      }
    });

    const result = await appService.getNotifications(userId);

    expect(result).toEqual({
      status: 'success',
      data: [
        {
          id: 1,
          type: 'info',
          user_id: userId,
          event_id: 1,
          event: {
            description: 'Event description',
            is_private: false,
            title: 'Event title',
            location: 'Event location',
            max_attendees: 100,
            start_date_time: '2023-01-01T00:00:00Z',
            end_date_time: '2023-01-01T01:00:00Z',
          },
        },
      ],
      timestamp: expect.any(String),
    });
  });

  it('should return error when no notifications found', async () => {
    const userId = 'test-user-id';

    supabaseClient.from.mockImplementation((table) => {
      if (table === 'notifications') {
        return {
          select: jest.fn().mockReturnThis(),
          eq: jest.fn().mockResolvedValue({ data: [], error: null }),
        };
      }
      return this;
    });

    const result = await appService.getNotifications(userId);

    expect(result).toEqual({
      status: 'error',
      message: 'No notifications found for user',
      timestamp: expect.any(String),
    });
  });

  it('should return error when fetching notifications fails', async () => {
    const userId = 'test-user-id';

    supabaseClient.from.mockImplementation((table) => {
      if (table === 'notifications') {
        return {
          select: jest.fn().mockReturnThis(),
          eq: jest.fn().mockResolvedValue({ data: null, error: 'Error fetching notifications' }),
        };
      }
      return this;
    });

    const result = await appService.getNotifications(userId);

    expect(result).toEqual({
      status: 'error',
      message: 'Error fetching notifications',
      timestamp: expect.any(String),
    });
  });
});
