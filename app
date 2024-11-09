#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>  // For sleep() on Unix; use Windows.h and Sleep() on Windows

#define MAX_ENTRIES 100

typedef struct {
    char date[11];
    int mood;
    char reason[100];
} MoodEntry;

MoodEntry entries[MAX_ENTRIES];
int entryCount = 0;

// Function Prototypes
void showMainMenu();
void logMood();
void viewAnalytics();
void startBreathingExercise();
void displayEncouragement();
void saveEntriesToFile();
void loadEntriesFromFile();
void calculateWeeklyAverage();

int main() {
    loadEntriesFromFile();
    printf("Welcome to the Mental Health Check-In App!\n");
    showMainMenu();
    saveEntriesToFile();
    return 0;
}

void showMainMenu() {
    int choice;
    do {
        printf("\n--- Main Menu ---\n");
        printf("1. Log Mood\n");
        printf("2. View Analytics\n");
        printf("3. Start Breathing Exercise\n");
        printf("4. Display Encouragement\n");
        printf("5. Exit\n");
        printf("Choose an option: ");
        scanf("%d", &choice);
        getchar(); // Consume newline character

        switch (choice) {
            case 1: logMood(); break;
            case 2: viewAnalytics(); break;
            case 3: startBreathingExercise(); break;
            case 4: displayEncouragement(); break;
            case 5: printf("Thank you for using the app! Take care.\n"); break;
            default: printf("Invalid choice. Try again.\n");
        }
    } while (choice != 5);
}

void logMood() {
    if (entryCount >= MAX_ENTRIES) {
        printf("Log is full. Cannot add more entries.\n");
        return;
    }

    MoodEntry entry;
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    snprintf(entry.date, sizeof(entry.date), "%02d-%02d-%04d", tm.tm_mday, tm.tm_mon + 1, tm.tm_year + 1900);

    printf("\nHow are you feeling today on a scale from 1 (Worst) to 10 (Best)? ");
    scanf("%d", &entry.mood);
    getchar(); // Consume newline character

    printf("What’s the main reason for this mood? ");
    fgets(entry.reason, sizeof(entry.reason), stdin);
    entry.reason[strcspn(entry.reason, "\n")] = 0; // Remove newline character

    entries[entryCount++] = entry;
    printf("Mood logged successfully!\n");
}

void viewAnalytics() {
    if (entryCount == 0) {
        printf("No entries to display.\n");
        return;
    }

    printf("\n--- Mood Analytics ---\n");
    printf("Total entries: %d\n", entryCount);

    int totalMood = 0;
    for (int i = 0; i < entryCount; i++) {
        totalMood += entries[i].mood;
    }
    printf("Average Mood: %.2f\n", totalMood / (float)entryCount);

    calculateWeeklyAverage();
}

void calculateWeeklyAverage() {
    if (entryCount < 7) {
        printf("Not enough entries for weekly average.\n");
        return;
    }

    int weeklyMood = 0;
    for (int i = entryCount - 7; i < entryCount; i++) {
        weeklyMood += entries[i].mood;
    }
    printf("Average Mood for Last 7 Days: %.2f\n", weeklyMood / 7.0);
}

void startBreathingExercise() {
    printf("\n--- Breathing Exercise ---\n");
    printf("Follow these steps:\n");

    for (int i = 0; i < 3; i++) {
        printf("Inhale... (Hold for 4 seconds)\n");
        sleep(4);
        printf("Hold... (Hold for 7 seconds)\n");
        sleep(7);
        printf("Exhale... (Exhale for 8 seconds)\n");
        sleep(8);
        printf("\n");
    }
    printf("Great job! Remember to take deep breaths throughout your day.\n");
}

void displayEncouragement() {
    const char *messages[] = {
        "You're doing amazing, keep going!",
        "Take it one step at a time. You got this!",
        "Remember, progress is progress, no matter how small.",
        "Believe in yourself and all that you are.",
        "Every day is a new opportunity. Seize it!"
    };
    srand(time(NULL));
    int index = rand() % 5;
    printf("\nEncouragement: %s\n", messages[index]);
}

void saveEntriesToFile() {
    FILE *file = fopen("mood_log.txt", "w");
    if (file == NULL) {
        perror("Error opening file for writing");
        return;
    }

    for (int i = 0; i < entryCount; i++) {
        fprintf(file, "%s,%d,%s\n", entries[i].date, entries[i].mood, entries[i].reason);
    }
    fclose(file);
}

void loadEntriesFromFile() {
    FILE *file = fopen("mood_log.txt", "r");
    if (file == NULL) {
        printf("No existing mood log found. Starting fresh.\n");
        return;
    }

    while (fscanf(file, "%10[^,],%d,%99[^\n]\n", entries[entryCount].date, &entries[entryCount].mood, entries[entryCount].reason) == 3) {
        entryCount++;
    }
    fclose(file);
}
