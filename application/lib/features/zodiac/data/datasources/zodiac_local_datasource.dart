import '../../domain/entities/zodiac_sign.dart';
import '../models/zodiac_sign_model.dart';

/// Local data source for zodiac signs
abstract class ZodiacLocalDataSource {
  /// Get all zodiac signs from local storage
  Future<List<ZodiacSignModel>> getZodiacSigns();

  /// Get zodiac sign by ID
  Future<ZodiacSignModel> getZodiacSignById(String id);

  /// Get zodiac sign by name
  Future<ZodiacSignModel> getZodiacSignByName(String name);
}

/// Implementation of local data source with mock data
class ZodiacLocalDataSourceImpl implements ZodiacLocalDataSource {
  // Mock zodiac sign data
  final List<ZodiacSignModel> _zodiacSigns = const [
    ZodiacSignModel(
      id: 'aries',
      name: 'Aries',
      symbol: '\u2648',
      element: ZodiacElement.fire,
      dateRange: 'March 21 - April 19',
      rulingPlanet: 'Mars',
      traits: 'Courageous, Energetic, Enthusiastic, Confident',
      description: 'Aries is the first sign of the zodiac, and those born under this sign are known for their boldness and pioneering spirit.',
      imageUrl: 'https://example.com/aries.png',
    ),
    ZodiacSignModel(
      id: 'taurus',
      name: 'Taurus',
      symbol: '\u2649',
      element: ZodiacElement.earth,
      dateRange: 'April 20 - May 20',
      rulingPlanet: 'Venus',
      traits: 'Reliable, Patient, Practical, Devoted',
      description: 'Taurus is an earth sign known for its reliability and love of comfort and luxury.',
      imageUrl: 'https://example.com/taurus.png',
    ),
    ZodiacSignModel(
      id: 'gemini',
      name: 'Gemini',
      symbol: '\u264A',
      element: ZodiacElement.air,
      dateRange: 'May 21 - June 20',
      rulingPlanet: 'Mercury',
      traits: 'Adaptable, Curious, Communicative, Versatile',
      description: 'Gemini is an air sign ruled by Mercury, known for its duality and communication skills.',
      imageUrl: 'https://example.com/gemini.png',
    ),
    ZodiacSignModel(
      id: 'cancer',
      name: 'Cancer',
      symbol: '\u264B',
      element: ZodiacElement.water,
      dateRange: 'June 21 - July 22',
      rulingPlanet: 'Moon',
      traits: 'Intuitive, Emotional, Protective, Caring',
      description: 'Cancer is a water sign ruled by the Moon, known for its nurturing and protective nature.',
      imageUrl: 'https://example.com/cancer.png',
    ),
    ZodiacSignModel(
      id: 'leo',
      name: 'Leo',
      symbol: '\u264C',
      element: ZodiacElement.fire,
      dateRange: 'July 23 - August 22',
      rulingPlanet: 'Sun',
      traits: 'Confident, Creative, Passionate, Generous',
      description: 'Leo is a fire sign ruled by the Sun, known for its dramatic and charismatic personality.',
      imageUrl: 'https://example.com/leo.png',
    ),
    ZodiacSignModel(
      id: 'virgo',
      name: 'Virgo',
      symbol: '\u264D',
      element: ZodiacElement.earth,
      dateRange: 'August 23 - September 22',
      rulingPlanet: 'Mercury',
      traits: 'Analytical, Practical, Loyal, Hardworking',
      description: 'Virgo is an earth sign known for its attention to detail and perfectionist tendencies.',
      imageUrl: 'https://example.com/virgo.png',
    ),
    ZodiacSignModel(
      id: 'libra',
      name: 'Libra',
      symbol: '\u264E',
      element: ZodiacElement.air,
      dateRange: 'September 23 - October 22',
      rulingPlanet: 'Venus',
      traits: 'Diplomatic, Fair-minded, Social, Artistic',
      description: 'Libra is an air sign ruled by Venus, known for its love of balance, harmony, and beauty.',
      imageUrl: 'https://example.com/libra.png',
    ),
    ZodiacSignModel(
      id: 'scorpio',
      name: 'Scorpio',
      symbol: '\u264F',
      element: ZodiacElement.water,
      dateRange: 'October 23 - November 21',
      rulingPlanet: 'Pluto',
      traits: 'Resourceful, Passionate, Loyal, Determined',
      description: 'Scorpio is a water sign ruled by Pluto, known for its intensity and transformative nature.',
      imageUrl: 'https://example.com/scorpio.png',
    ),
    ZodiacSignModel(
      id: 'sagittarius',
      name: 'Sagittarius',
      symbol: '\u2650',
      element: ZodiacElement.fire,
      dateRange: 'November 22 - December 21',
      rulingPlanet: 'Jupiter',
      traits: 'Optimistic, Adventurous, Honest, Philosophical',
      description: 'Sagittarius is a fire sign ruled by Jupiter, known for its adventurous and optimistic spirit.',
      imageUrl: 'https://example.com/sagittarius.png',
    ),
    ZodiacSignModel(
      id: 'capricorn',
      name: 'Capricorn',
      symbol: '\u2651',
      element: ZodiacElement.earth,
      dateRange: 'December 22 - January 19',
      rulingPlanet: 'Saturn',
      traits: 'Disciplined, Responsible, Ambitious, Patient',
      description: 'Capricorn is an earth sign ruled by Saturn, known for its ambition and practicality.',
      imageUrl: 'https://example.com/capricorn.png',
    ),
    ZodiacSignModel(
      id: 'aquarius',
      name: 'Aquarius',
      symbol: '\u2652',
      element: ZodiacElement.air,
      dateRange: 'January 20 - February 18',
      rulingPlanet: 'Uranus',
      traits: 'Independent, Humanitarian, Original, Innovative',
      description: 'Aquarius is an air sign ruled by Uranus, known for its originality and humanitarian ideals.',
      imageUrl: 'https://example.com/aquarius.png',
    ),
    ZodiacSignModel(
      id: 'pisces',
      name: 'Pisces',
      symbol: '\u2653',
      element: ZodiacElement.water,
      dateRange: 'February 19 - March 20',
      rulingPlanet: 'Neptune',
      traits: 'Compassionate, Artistic, Intuitive, Gentle',
      description: 'Pisces is a water sign ruled by Neptune, known for its empathy and creative nature.',
      imageUrl: 'https://example.com/pisces.png',
    ),
  ];

  @override
  Future<List<ZodiacSignModel>> getZodiacSigns() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _zodiacSigns;
  }

  @override
  Future<ZodiacSignModel> getZodiacSignById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _zodiacSigns.firstWhere(
      (sign) => sign.id == id,
      orElse: () => throw Exception('Zodiac sign not found'),
    );
  }

  @override
  Future<ZodiacSignModel> getZodiacSignByName(String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _zodiacSigns.firstWhere(
      (sign) => sign.name.toLowerCase() == name.toLowerCase(),
      orElse: () => throw Exception('Zodiac sign not found'),
    );
  }
}
