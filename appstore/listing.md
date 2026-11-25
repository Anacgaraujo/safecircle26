# SafeCircle 3.0: App Store Connect listing

Paste each field into App Store Connect → App Information / version page.
Character limits are Apple's; the counts in brackets are for the text as written.

---

## App Information

| Field | Value |
|---|---|
| **Name** (30) | `SafeCircle: Safety & Location` [29] |
| **Subtitle** (30) | `Live location, check-ins & SOS` [30] |
| **Primary category** | Social Networking (current). Consider **Navigation** or **Lifestyle** as secondary. |
| **Content rights** | No third-party content (already set) |
| **Age rating** | 4+ is likely (no objectionable content). Answer "No" to all content questions. |

> Name alternatives, if "SafeCircle: Safety & Location" is taken:
> `SafeCircle – Family Safety` [26] · `SafeCircle: Get Home Safe` [25]

---

## Promotional Text (170, can change without a review)

```
Walking home late? Start a journey, set your check-ins, and if you don't confirm in time, your circle is alerted with your live location. Free, private, built for you.
```
[167]

---

## Description (4000)

```
Someone always knows you're safe.

SafeCircle keeps the people you trust one tap away. Share your live location with your circle, plan journeys with check-ins, and send an SOS in a single hold. If something goes wrong, the right people find out right away, with your location.

PLAN A JOURNEY WITH CHECK-INS
Heading out on a date, a night out, a late shift or a long drive? Pick the times you'll check in. Confirm each one with your PIN. Miss one, and your circle is alerted automatically with where you were last seen. Running behind? Just move the check-in.

A SILENT PANIC PIN
If someone forces you to open the app, enter your panic PIN instead of your safety PIN. The screen looks completely normal, but your circle is silently alerted and told not to call you.

SOS IN ONE HOLD
Hold the SOS button and your circle is alerted in the app. Your emergency contacts get a text with a link to your live location, even if they don't have SafeCircle. Call emergency services from the same screen.

LIVE MAP OF YOUR CIRCLE
See where your family and friends are, whether they're moving or settled, and how much battery they have left. Call or message anyone straight from the map.

PLACES: KNOW WHEN THEY ARRIVE
Add home, school, work or the gym. Your circle gets a notification when someone arrives or leaves, so you don't have to ask "are you home yet?"

TRIP HISTORY
Look back at today's trips and replay a route on the map.

CIRCLES FOR EVERY PART OF YOUR LIFE
Create circles for family, roommates, your running club or your night-out crew. Invite people by text. You choose what each circle sees, and you can pause sharing anytime.

EMERGENCY CONTACTS WITHOUT THE APP
Add parents, partners or friends as emergency contacts by phone number. They're texted when you send an SOS, miss a check-in or use your panic PIN, and again when you're safe.

PRIVATE BY DESIGN
Your location is only shared with circles you've joined. Pause sharing whenever you want. Journeys, check-ins and SOS keep working while sharing is paused.

SafeCircle is for students walking home, parents with teens, people meeting someone new, solo travelers, night-shift workers, and anyone who wants someone to know they made it.

Important: SafeCircle does not replace emergency services. In an emergency, call your local emergency number. Continued use of GPS running in the background can decrease battery life.
```

---

## Keywords (100, comma-separated, no spaces)

Do not repeat words already in the name or subtitle (Apple indexes those already).

```
family,friends,tracker,find,gps,share,panic,emergency,alert,walk,home,journey,women,teen,circle
```
[95]

---

## What's New in This Version (3.0)

```
SafeCircle 3.0 is a complete rebuild.

• Journeys with scheduled check-ins: miss one and your circle is alerted
• Silent panic PIN that looks normal but calls for help
• One-hold SOS that texts your emergency contacts your live location
• Live map of your circle with battery and movement status
• Places: get notified when someone arrives or leaves
• Trip history and route replay
• Invite friends and family by text
```

---

## URLs

| Field | Value |
|---|---|
| Support URL | _your support page, e.g. https://safecircle.org/support_ |
| Marketing URL | _optional, e.g. https://safecircle.org_ |
| Privacy Policy URL | _required, because the app collects location_ |

---

## App Privacy (nutrition label)

Data **linked to the user**, used for **App Functionality**, **not** used for tracking:

- **Location**: Precise Location (live map, journeys, SOS)
- **Contact Info**: Name, Phone Number, Email Address (account, invites, SMS alerts)
- **Contacts**: only if the user picks emergency contacts from their address book
- **User Content**: Photos (profile photo)
- **Identifiers**: User ID (Firebase Auth)
- **Purchases**: Purchase History (membership, via RevenueCat)

---

## App Review notes

```
SafeCircle is a personal-safety app. Location is shared only with circles the user has joined.

Demo account (Alex Morgan, in the "Family" circle with a second test member, Jamie Rivera, and two emergency contacts):
  Email: review@safecircle.me
  Password: <add the demo password here, only in App Store Connect>
  Safety PIN: 1234   Panic PIN: 9999

Background location is used while sharing is on and during an active journey, so the circle can see where the user is and an overdue check-in can include the last known position. The app only asks for "While Using" permission; updates continue after switching apps with the blue location indicator showing, and stop if the app is closed. The user can pause sharing at any time.

Membership: SafeCircle is $0.99/month with a 3-day free trial (subscription org.SafeCircle.membership.monthly). SOS is always free, so it can be tested without subscribing. Sign in with a sandbox account to test the purchase.

SMS: emergency contacts are texted (via Twilio) only when the user sends an SOS, misses a check-in, enters the panic PIN, or adds them as a contact. Every text includes opt-out instructions.

To test without sending real alerts, please use the demo account: its emergency contacts are fictional 555 numbers that have not agreed to texts, so an SOS from it never texts anyone.
```

---

## Images in this folder

| Asset | Size | Where it goes |
|---|---|---|
| `screenshots/iphone-6.9/01…06.png` | 1320 × 2868 | iPhone 6.9" Display (Apple scales these down for smaller iPhones) |
| `screenshots/iphone-6.5/01…06.png` | 1284 × 2778 | iPhone 6.5" Display (only needed if you want to supply it separately) |
| `screenshots/ipad-13/01…06.png` | 2064 × 2752 | iPad 13" Display (required: the app targets iPad) |
| `preview/app-preview-6.9.mp4` | 886 × 1920, 30 fps, ~25 s | App Preview, iPhone 6.9" |
| `header/header-1920x1080.png` | 1920 × 1080 | Promotional header with headline: website, social, featuring nomination |
| `header/event-card-1920x1080-no-text.png` | 1920 × 1080 | In-app event card / event details artwork (Apple asks for no text in event media) |
| `header/search-preview.png` | — | Mock of how the listing looks in App Store search (for review, not upload) |

To change copy or redraw: edit `src/shot.html` / `src/kit.js`, then run `node src/render.js shots` and `node src/render-preview.js <tmp dir>` (needs `puppeteer-core` and `ffmpeg`).

Screenshot order matters: only the **first three** appear in search results, so they carry the main promise (live map, check-ins, SOS).
