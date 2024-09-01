import { Test, TestingModule } from '@nestjs/testing';
import { UserRecommendationsController } from './user-recommendations.controller';
import { UserRecommendationsService } from './user-recommendations.service';

describe('UserRecommendationsController', () => {
  let controller: UserRecommendationsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserRecommendationsController],
      providers: [UserRecommendationsService],
    }).compile();

    controller = module.get<UserRecommendationsController>(UserRecommendationsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
