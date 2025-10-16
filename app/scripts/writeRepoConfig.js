const fs = require( 'fs' )
const path = require( 'path' )

const config = {
    owner: process.env.BATTERY_REPO_OWNER || 'actuallymentor',
    name: process.env.BATTERY_REPO_NAME || 'battery',
    branch: process.env.BATTERY_REPO_BRANCH || 'main'
}

const target_path = path.resolve( __dirname, '..', 'repo.config.json' )

try {
    fs.writeFileSync( target_path, JSON.stringify( config, null, 2 ), 'utf8' )
    console.log( `📦 Repo config written to ${ target_path }` )
} catch ( error ) {
    console.error( 'Failed to write repo config file', error )
    process.exitCode = 1
}
