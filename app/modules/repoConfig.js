const fs = require( 'fs' )
const path = require( 'path' )

const DEFAULTS = {
    owner: 'actuallymentor',
    name: 'battery',
    branch: 'main'
}

const resolve_config = () => {

    try {
        const config_path = path.resolve( __dirname, '..', 'repo.config.json' )
        if( fs.existsSync( config_path ) ) {
            const parsed = JSON.parse( fs.readFileSync( config_path, 'utf8' ) )
            return {
                owner: parsed.owner || DEFAULTS.owner,
                name: parsed.name || DEFAULTS.name,
                branch: parsed.branch || DEFAULTS.branch
            }
        }
    } catch ( error ) {
        console.log( 'Unable to read repo.config.json, falling back to defaults', error )
    }

    return DEFAULTS
}

const file_config = resolve_config()

module.exports = {
    owner: process.env.BATTERY_REPO_OWNER || file_config.owner,
    name: process.env.BATTERY_REPO_NAME || file_config.name,
    branch: process.env.BATTERY_REPO_BRANCH || file_config.branch
}
