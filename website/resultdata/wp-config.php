<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'resultdata' );

/** MySQL database username */
define( 'DB_USER', 'root' );

/** MySQL database password */
define( 'DB_PASSWORD', '' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'ENGR2!k2JE>!}lRDg[5O8izAn=K`lNlAyo_bqc!Q KOlxkqG23[=HlqeIgQ8BcA+' );
define( 'SECURE_AUTH_KEY',  'CUAH~C=-EQR,`EU`v3`31kXed7$v;x>%bN-6)?&(azapw5x!m?nv^&r0ru4&cb-s' );
define( 'LOGGED_IN_KEY',    '~FYI>wZKydsAi+nu)%tP@CP4G*l2(~ebSlBHrO1jt,/dG3.ukMz,bOJ6*r>X}OZw' );
define( 'NONCE_KEY',        'pGR)VuPZGT07IVtPC[TOk91~}=$0%^`kQ.Qvj5}jw[tl-ncc<T3GgQHjq=A6v15X' );
define( 'AUTH_SALT',        'XC+*wz^,aiV]*gi9&R;3Kf4V/~f>[ict1q!9>,99f:80%XpGC?Y.%beuQA}a7%YD' );
define( 'SECURE_AUTH_SALT', 'LRM%#9&=GJEbt@(.Oh5IQBgPwC;qsH2{Te97QtcZ,;mUz(rQm#8 rVX$!?!HE*T(' );
define( 'LOGGED_IN_SALT',   'OV N^::mqJGmmwqtVyArV8ia9mY$xPju!E0f^1hJ0fT.HmV+8KyP_{&4UIN4w,_7' );
define( 'NONCE_SALT',       'KoQri>bVBu7M_ney77{K$8>U.QfBv#A-A#Vw#Whv*4Ji$_O3UgA .T |xB6z14G^' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'rd_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
